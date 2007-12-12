From: "Brett Maton" <Brett.Maton@simplyhealth.co.uk>
Subject: mdadm break / restore soft mirror
Date: Wed, 12 Dec 2007 22:08:06 -0000
Message-ID: <05ED21952E28E94E8352836547A6BA37042318B3@achmsx001.hsa.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, 



  Question for you guys. 



  A brief history: 

  RHEL 4 AS 

  I have a partition with way to many small files on (Usually around a couple of million) that needs to be backed up, standard



  methods mean that a restore is impossibly slow due to the sheer volume of files. 

  Solution, raw backup /restore of the device.  However the partition is permanently being accessed. 



  Proposed solution is to use software raid mirror.  Before backup starts, break the soft mirror unmount and backup partition



  restore soft mirror and let it resync / rebuild itself. 



  Would the above intentional break/fix of the mirror cause any problems? 



Regards, 

Brett 



Brett Maton 

Linux Consultant 

RHCE #805007238628267 



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

