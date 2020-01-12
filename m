From: Leslie Rhorer <lesrhorer@att.net>
Subject: mdadm not sending email
Date: Sun, 12 Jan 2020 03:48:26 -0600
Message-ID: <6c7766cb-8698-e44e-e767-000d5dea5833@att.net>
References: <87skiztloo.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87skiztloo.fsf@hades.wkstn.nix>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 ??? I recently upgraded one of my servers to Debian Buster.? I have 
been using sSMTP as my MTA, but unfortunately it is no longer 
maintained.? I installed msmtp, instead, but now my mesages are no 
longer going out from mdadm.? I can run the command:

echo "Subject: Test: | sendmail lesrhorer@att.net

and it works.? If I try:

mdadm --monitor --scan --test -1

I get:

sendmail: the server did not accept the mail
sendmail: server message: 550 Request failed; Mailbox unavailable
sendmail: could not send mail (account default from /etc/msmtprc)

and from /var/log/mail.err:

Jan 12 03:43:40 RAID-Server msmtp: host=outbound.att.net tls=on auth=on 
user=lesrhorer@att.net from=lesrhorer@att.net 
recipients=lesrhorer@att.net smtpstatus=550 smtpmsg='550 Request failed; 
Mailbox unavailable' errormsg='the server did not accept the mail' 
exitcode=EX_UNAVAILABLE
