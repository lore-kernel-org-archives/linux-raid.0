From: Rick Bragg <lists@gmnet.net>
Subject: raid10 How do I tell what side of the mirror a disk is on?
Date: Fri, 29 Jan 2010 10:00:47 -0500
Message-ID: <1264777247.29409.64.camel@thor>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I recently posted a question to find out how to tell what is sda, b, c,
etc... and I am now using smartctl to get the serial numbers and all is
really great.  Thanks everyone for that info!

Another puzzle is with raid10, there are 2 used in a stripe, then that
stripe is mirrored with the other 2.  My question is how can I tell
"what 2 disks can fail?"  In other words, how can I tell for example if
sda and b are stiped? and that c and d are a mirror of a and b?  How can
I see what is happening with that?  Is there a way to tell?  

Thanks
Rick



