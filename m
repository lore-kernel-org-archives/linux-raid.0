From: PFC <lists@peufeu.com>
Subject: Re: how to clone a disk
Date: Sat, 11 Mar 2006 13:40:29 +0100
Message-ID: <op.s581hroxcigqcu@apollo13>
References: <1142038562.20484.234.camel@localhost.localdomain> <dd43dcfb0603110353g1a4d51f6y9fe4caa4007b6e9c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dd43dcfb0603110353g1a4d51f6y9fe4caa4007b6e9c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Paul M." <paul@gpmidi.net>, mingz@ele.uri.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>> I have a raid5 array that contain 4 disk and 1 spare disk. now i saw one
>> disk have sign of going fail via smart log.

	Better safe than sorry... replace the failing disk and resync, that's all.

	You might want to do "cat /dev/md# > /dev/null", or "cat /dev/hd?  
>/dev/null" first. This is to be sure there isn't some yet-unseen bad  
sector on some other drive which would screw your resync.
