From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Force parity resync on raid5?
Date: Thu, 12 Aug 2004 13:15:24 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F013446A3@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Philip Molter <philip@corp.texas.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

But, does this occur for full stripe writes?

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Philip Molter
Sent: Thursday, August 12, 2004 1:08 PM
To: linux-raid@vger.kernel.org
Subject: Re: Force parity resync on raid5?

No, it wouldn't.  In RAID5 implementations, parity isn't recalculated 
when you write to a RAID,  It's updated.  My understanding is that 
typical implementations are, *VERY* basically:

read the old data
xor with the new data
read the parity data
xor with the parity data
write the new data
write the new parity data

