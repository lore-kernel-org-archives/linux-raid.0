From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm and email warnings
Date: Thu, 29 Jan 2004 12:50:18 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16408.26330.955646.529858@notabene.cse.unsw.edu.au>
References: <db.225a512.2d4965fb@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from AndyLiebman@aol.com on Wednesday January 28
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 28, AndyLiebman@aol.com wrote:
> 
> For instance, I see that I can enter an email address with the flag -m and 
> the address. But do I need to specify a program that will send that email? It 
> looks that way to me. Can I use KDE Mail to do the job? Or do I need to use 
> something that doesn't involve a GUI? 

No, you don't need to specify a program to send the mail.  mdadm
already knows to use sendmail.
The --program option is to specify a program that can do other things
with alerts from mdadm.  e.g. log them, page a sysadmin, send a
differently formatted email. etc.

NeilBrown
