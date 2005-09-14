From: vinnakota chaitanya <chaitanyaa_v@yahoo.com>
Subject: Implementing Encryption and Decryption in Raid Device Driver.
Date: Tue, 13 Sep 2005 22:14:47 -0700 (PDT)
Message-ID: <20050914051447.13030.qmail@web54703.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Friends,
 
I'am working on a "RAID 5 Controller" device to which
4 SATA hard drives are connected each of size 80GB.
 
My requirement is implementing encryption &
decrpyption for the device. As we don't have any
filesystem on the target, we are falling on raid
device driver . The first thing I want to ask is 
 
 1. Whether this approach is recommendable or not.
  
2. If recommendable then, what are the hooks wherein  
    we can implement encryption and decryption.
 
    We are considering  to implement encryption in 
   "raid5_make_request" and decrytpion in 
   "raid5_end_read_request" in raid5.c 
 
 
  Are we going the right way.   PLEASE SUGGEST US.
 
  
 Thanks & Regards
  Chaitanya.
 

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
