From: commentsabout@riseup.net
Subject: Encrypted software RAID1 with Debian Stretch
Date: Thu, 31 Aug 2017 23:58:38 +0000
Message-ID: <28c61e8c14f44ec6727b8f3fb3c80c98@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

(this is a cross-post from debian-users mailing list
https://groups.google.com/d/msg/linux.debian.user/jjdr6LXaOm8/MOoVVo0lAwAJ
)

Here is a picture of what I'm trying to achieve:
https://imgur.com/a/DAM8D (the "Today" column). 

I am trying to build a home backup system. The system (Debian Stretch) 
will be on a SSD. For the time being, I only have one pair of HDDs (the 
"Today" column in the picture) ; in the future (the "Future" column), I 
would like to add other pairs of HDD to store other kind of data. 

This backup system will only be turned on when needed, I don't plan on 
using it as some sort of server or a NAS. 

We are talking about software RAID1. 

I would like everything to be encrypted (FDE), from the system (/ and 
/swap) to the RAID1 drives. 

If possible, I would like to have different encryption keys for the 
system and the various RAID1 pairs (in the "Future" column in the 
picture, one for the system, one for "work", one for "family", one for 
"misc"). So that I can give the system encryption passphrase, "family" 
and "misc" ones to my wife and keep the "work" one for myself. 

I'm a complete noob when it comes to this kind of operations so I'm
looking for a step by step ELI5 explanation (I have tried to use the
Debian graphical installer to achieve this but have failed because I was
just messing around with the options trying to figure out what to do). 

Thank you in advance for your help :) 

CA 
