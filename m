From: Stefan Neufeind <linux-raid@stefan-neufeind.de>
Subject: Extendable raid - with soft-raid 5 and new mdadm?
Date: Sun, 31 Oct 2004 19:30:10 +0100
Message-ID: <41852F32.3000405@stefan-neufeind.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I was wondering how to set up an extendable raid, just for backup/data 
storage. It doesn't need to be high-performant - so imho I don't need a 
hardware-raid.

To provide a minimum of security I was wondering about using a soft-raid 
5 under Linux. However, I need to be able to extend the raid, if backup 
demand rises. Therefor I plan to use a raid 5 with three or four devices 
at the moment and need to be able to add more as the requirements grow.

I saw that in mdadm, version 1.7.0, there was a "grow"-feature 
introduced. However, at present it just works fine for raid 1 as far as 
I know. Can somebody tell me, if it will shortly (in the next few month) 
be possible to extend a soft-raid 5 with mdadm as well? What do you 
think about data-security? And do I need a plain raid 5 with ext3 on it 
or should I maybe put an LVM on top of raid 5 to be flexible?


Your feedback would be very much appreciated.

Regards,
  Stefan
