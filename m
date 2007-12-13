From: "Brett Maton" <Brett.Maton@simplyhealth.co.uk>
Subject: RE: mdadm break / restore soft mirror
Date: Thu, 13 Dec 2007 07:02:23 -0000
Message-ID: <05ED21952E28E94E8352836547A6BA37042318B4@achmsx001.hsa.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>, Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>Proposed solution is to use software raid mirror.  Before backup starts,

>>break the soft mirror unmount and backup partition



>I use this method for backup once a week.



>One challenge is drives aren't great at steaming data quickly (for the resync)

>while also doing a lot of random access. Having a little extra redundancy (think

>3 or more drives in the RAID-1) can really help.



>>If you can be certain that the device that you break out of the mirror

>>is never altered, then you could add an internal bitmap while the

>>array is split and the rebuild will go much faster.



When the device is split from the mirror it will only be read as a raw device by the backup

software (NetBackup) and not actually mounted during the process so it really shouldn't be

modified in anyway at all.

Also during the backup window files will only be being created on remaining device (reports pdf's) so random access shouldn't be a problem either.



How do I create the internal bitmap?  man mdadm didn't shed any light and my brief excursion into google wasn't much more helpful.



The version I have installed is mdadm-1.12.0-5.i386 from RedHat which would appear to be way out of date!



Thanks for you help,

Brett

-----------------------------------------------------------------------------------------------

This email, and the contents contained within, are private

and confidential between the sender and the individual(s)

to whom it is addressed.

The contents do not necessarily represent the views of Simplyhealth Group

Limited.



In the event of misdirection, the recipient is prohibited from 

using, copying or disseminating it or any information contained in it.

If you have received this email in error please notify Simplyhealth

immediately by telephone on 0845 075 2020, or by email to 

network.administrator@simplyhealth.co.uk



Simplyhealth Group Limited is registered and incorporated in England and Wales  

as a company limited by guarantee. Its registered office is at Hambleden House, 

Waterloo Court, Andover, Hampshire, SP10 1LQ, registered no. 5445654. We 

may record or monitor telephone calls to help improve our service and protect our 

members.

-----------------------------------------------------------------------------------------------

