From: Dragos <dragos@mpigani.org>
Subject: assemble vs create an array.......
Date: Thu, 29 Nov 2007 22:42:21 -0500
Message-ID: <474F869D.5040503@mpigani.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Hello,
I had created a raid 5 array on 3 232GB SATA drives. I had created one 
partition (for /home) formatted with either xfs or reiserfs (I do not 
recall).
Last week I reinstalled my box from scratch with Ubuntu 7.10, with mdadm 
v. 2.6.2-1ubuntu2.
Then I made a rookie mistake: I --create instead of --assemble. The 
recovery completed. I then stopped the array, realizing the mistake.

1. Please make the warning more descriptive: ALL DATA WILL BE LOST, when 
attempting to created an array over an existing one.
2. Do you know of any way to recover from this mistake? Or at least what 
filesystem it was formated with.

Any help would be greatly appreciated. I have hundreds of family digital 
pictures and videos that are irreplaceable.
Thank you in advance,
Dragos

