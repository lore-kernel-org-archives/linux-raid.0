From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Is My Data DESTROYED?!
Date: Fri, 23 Oct 2009 18:37:08 -0400
Message-ID: <4AE23014.5070005@tmr.com>
References: <151153.66698.qm@web38804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <151153.66698.qm@web38804.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

adfas asd wrote:
> I don't understand exactly what it is to be done.  If I can mount using a different superblock, do I then remove one of the drives from the array so I can put that drive away with my data until I can buy another drive to back up the data to?  If so, how?
>
> How is it that the superblock on -both- drives got destroyed?  Isn't RAID10 supposed to be mirrored?
>   

It is mirrored, do you understand what that means? It means that if your 
filesystem screws up and writes crap to one drive, raid will faithfully 
write crap to the mirror copy, thereby giving you a fully reliable fully 
hosed filesystem. Your problem isn't that your raid array has lost your 
data, but rather that your filesystem has been trashed. And from your 
comments in another post about reinstalling jfs utilities, I suspect 
that a nice clean removal of those utilities has some element of human 
intervention involved.

-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.

