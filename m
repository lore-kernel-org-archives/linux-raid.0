From: Leslie Rhorer <lesrhorer@att.net>
Subject: Re: mdadm not sending email
Date: Mon, 13 Jan 2020 08:00:32 -0600
Message-ID: <381d32b6-eee7-63c6-7cb4-64a58a0f6796@att.net>
References: <87skiztloo.fsf@hades.wkstn.nix>
 <6c7766cb-8698-e44e-e767-000d5dea5833@att.net>
 <24091.5497.253499.381022@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24091.5497.253499.381022@quad.stoffel.home>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

	I forgot to send this out to the list.  I apologize for any duplicates.

On 1/12/2020 6:47 AM, John Stoffel wrote:
> Leslie>  ??? I recently upgraded one of my servers to Debian Buster.?
> Leslie> I have been using sSMTP as my MTA, but unfortunately it is no
> Leslie> longer maintained.? I installed msmtp, instead, but now my
> Leslie> mesages are no longer going out from mdadm.? I can run the
> Leslie> command:
>
> This is a problem with your mail setup, not with mdadm.  I suspect you
> need to configure msmtp to use TLS and/or to submit the email to port
     It is using TLS.
> 587 on att.net, where you do a full authenticated login.

     Nope, 465, which by the way is the default for SSL/TLS, and I am 
doing a full authenticated login.  Now, it is certainly arguable, 
perhaps even likely, my mail setup has a problem, but without knowing 
specifically what mdadm is sending out, I am going to be hard pressed to 
know what I need to modify in my mail setup.

     In the earlier version of mdadm, the mail utility (specified in 
/etc/mdadm/mdadm.conf) was the script /usr/bin/mdadm_notify.  I have no 
idea how or whatt he newer version f mdadm sends out.

>
> Look at the examples here:
>
> https://wiki.alpinelinux.org/wiki/Relay_email_to_gmail_(msmtp,_mailx,_sendmail
> https://wiki.debian.org/msmtp


     I had already looked at both of those, and although the 
configuration for att.net is different than for gmail, nothing jumps out 
at me.


Here is my configuration for msmtp:

# Example for a system wide configuration file

# A system wide configuration file is optional.
# If it exists, it usually defines a default account.
# This allows msmtp to be used like /usr/sbin/sendmail.
account default

# The SMTP smarthost
host outbound.att.net

# Use TLS on port 465
port 465
tls on
tls_starttls off

# Construct envelope-from addresses of the form "user@oursite.example"
#auto_from on
#maildomain att.net

from lesrhorer@att.net
user lesrhorer@att.net
auth on
password XXXXXXXXXXX

# Syslog logging with facility LOG_MAIL instead of the default LOG_USER
syslog LOG_MAIL

Mail is working on another server that still uses ssmtp.  Here is the 
configuration:

# Config file for sSMTP sendmail
#
# The person who gets all mail for userids < 1000
# Make this empty to disable rewriting.
root=lesrhorer

# The place where the mail goes. The actual machine name is required no
# MX records are consulted. Commonly mailhosts are named mail.domain.com
mailhub=outbound.att.net

# Where will the mail seem to come from?
rewriteDomain=att.net

# The full hostname
hostname=localhost

# Are users allowed to set their own From: address?
# YES - Allow the user to specify their own From: address
# NO - Use the system generated From: address
FromLineOverride=YES

AuthUser=lesrhorer@att.net
AuthPass=XXXXXXXXXXXXX
UseTLS=YES

>
> And follow the debuging info these guides give.  Once you get email

     I don't see any debugging recommendations in either document.


     One interesting thing: When I run the monitor / test command on the 
older system, sendmail complains about the mailbox being unavailable, 
but it still sends out the email.
