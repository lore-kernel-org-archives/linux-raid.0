From: AndyLiebman@aol.com
Subject: Re: mdadm and email warnings
Date: Thu, 29 Jan 2004 06:32:03 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <86.4133f77.2d4a4933@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you Neil. I guess my question is, can I invoke Mozilla mail or KMail or 
something that's easy to configure to get my warnings?

The "fileserver" that I want to monitor with mdadm isn't set up as a mail 
server. And, frankly, I'm completely baffled about how to configure sendmail to 
just act as an intermediary for sending and receiving mail from an outside 
Internet Service Provider. Is there a simple mail client -- even one that's just 
text based (Pine?) that's easy to configure so that it will work with mdadm? 
I'm not being lazy. I just don't want to become an expert in every aspect of 
Linux services just to run a local file server. 

Appreciate your thoughts. 

Andy Liebman

> 
> For instance, I see that I can enter an email address with the flag -m and 
> the address. But do I need to specify a program that will send that email? 
It 
> looks that way to me. Can I use KDE Mail to do the job? Or do I need to use 
> something that doesn't involve a GUI? 

No, you don't need to specify a program to send the mail.  mdadm
already knows to use sendmail.
The --program option is to specify a program that can do other things
with alerts from mdadm.  e.g. log them, page a sysadmin, send a
differently formatted email. etc.

NeilBrown
