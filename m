From: Vincent Schut <schut@sarvision.nl>
Subject: looking for advice on raid drives upgrade
Date: Wed, 30 Mar 2011 11:46:19 +0200
Message-ID: <imuu5b$gaf$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

one of my raid's is currently a raid5 with 4 1TB drives, which I'm going 
to upgrade by replacing all drives with 2TB drives.
Main question: what is recommended:

- offline the raid, dd(rescue) each 1TB drive onto a new 2TB one, 
replace drives, put raid online again

or:
- manually replace one drive at a time, and let the raid recover and 
thus write the data onto the new drive?

As far as I know all current drives are healthy; regularly SMART 
monitoring and raid checks have not ringed any bells sofar.

I guess offlining and dd-ing would be more secure, but I might miss 
something and would like to hear other considerations from people more 
experienced in this area.

Regards,
Vincent Schut.

