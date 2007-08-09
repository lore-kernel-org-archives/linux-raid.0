From: Bill Davidsen <davidsen@tmr.com>
Subject: Another RAID level migration question
Date: Thu, 09 Aug 2007 17:46:26 -0400
Message-ID: <46BB8B32.9010007@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have an array on two drives which was set up as a RAID-0, because I 
needed the space and performance. Now I have another identical drive, 
ideally I would like to get to RAID-5, but I don't think that is going 
to fly, so how about RAID-4? I could create with a missing parity drive, 
then add the drive and see if it will rebuild.

I hope to test this using loop devices, but time is fairly short right now.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

