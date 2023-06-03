defmodule Painless.Repo.Migrations.FlattenAccountEntries do
  use Ecto.Migration

  def up do
    execute """
    ALTER TABLE entries
      ADD COLUMN tenancy_id integer,
      ADD COLUMN transaction_type varchar;
    """

    execute """
    WITH entries_and_ledger AS (
       SELECT l.tenancy_id, LOWER(l.acct_type) as transaction_type, e.id as entry_id,
              CASE WHEN l.acct_type = 'Receivable' THEN  e.amount * -1 ELSE e.amount END AS amount
      FROM ledgers l
      INNER JOIN entries e
        ON l.id = e.ledger_id
    )
    UPDATE entries
      SET tenancy_id = el.tenancy_id,
          transaction_type = el.transaction_type,
          amount = el.amount
      FROM entries_and_ledger el
      WHERE el.entry_id = id;
    """

    execute """
    ALTER TABLE entries
      DROP COLUMN ledger_id;
    """
  end

  def down, do: :ok
end
