From: "John Stoffel" <john@stoffel.org>
Subject: Re: mdadm not sending email
Date: Sun, 12 Jan 2020 07:47:53 -0500
Message-ID: <24091.5497.253499.381022@quad.stoffel.home>
References: <87skiztloo.fsf@hades.wkstn.nix>
        <6c7766cb-8698-e44e-e767-000d5dea5833@att.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c7766cb-8698-e44e-e767-000d5dea5833@att.net>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lesrhorer@att.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Leslie>  ??? I recently upgraded one of my servers to Debian Buster.?
Leslie> I have been using sSMTP as my MTA, but unfortunately it is no
Leslie> longer maintained.? I installed msmtp, instead, but now my
Leslie> mesages are no longer going out from mdadm.? I can run the
Leslie> command:

This is a problem with your mail setup, not with mdadm.  I suspect you
need to configure msmtp to use TLS and/or to submit the email to port
587 on att.net, where you do a full authenticated login.

Look at the examples here:

https://wiki.alpinelinux.org/wiki/Relay_email_to_gmail_(msmtp,_mailx,_sendmail
https://wiki.debian.org/msmtp

And follow the debuging info these guides give.  Once you get email
working properly, mdadm will send emails.  


Leslie> echo "Subject: Test: | sendmail lesrhorer@att.net

Leslie> and it works.? If I try:

Leslie> mdadm --monitor --scan --test -1

Leslie> I get:

Leslie> sendmail: the server did not accept the mail
Leslie> sendmail: server message: 550 Request failed; Mailbox unavailable
Leslie> sendmail: could not send mail (account default from /etc/msmtprc)

Leslie> and from /var/log/mail.err:

Leslie> Jan 12 03:43:40 RAID-Server msmtp: host=outbound.att.net tls=on auth=on 
Leslie> user=lesrhorer@att.net from=lesrhorer@att.net 
Leslie> recipients=lesrhorer@att.net smtpstatus=550 smtpmsg='550 Request failed; 
Leslie> Mailbox unavailable' errormsg='the server did not accept the mail' 
Leslie> exitcode=EX_UNAVAILABLE
