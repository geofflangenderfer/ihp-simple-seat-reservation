module Web.Mail.Reservations.Confirmation where

import Web.View.Prelude
import IHP.MailPrelude

data ConfirmationMail = ConfirmationMail
    { reservation :: Reservation
    , venue :: Venue
    }

instance BuildMail ConfirmationMail where
    subject = status |> \case
            Accepted -> "Reservation Accepted"
            Rejected -> "Reservation Rejected"
            _ -> ""
        where
            reservation = get #reservation ?mail
            status = get #status reservation

    to ConfirmationMail { .. } = Address { addressName = Just "Firstname Lastname", addressEmail = "fname.lname@example.com" }
    from = "hi@example.com"
    html ConfirmationMail { .. } = [hsx|
        Hello Person (#{get #personIdentifier reservation}),

        Your reservation for venue "{get #title venue}" is now <strong>{get #status reservation}</strong>

        See <a href={ShowReservationAction (get #id reservation)}>Reservation</a>
    |]
