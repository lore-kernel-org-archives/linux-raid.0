From: "Mark Ryden" <markryde@gmail.com>
Subject: type-0.90.0 superblock and "md-1" superblocks
Date: Mon, 9 Oct 2006 16:16:16 +0200
Message-ID: <dac45060610090716s7afb4f95mb639866d11a2347e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I wonder what is the "type-0.90.0" superblock and "md-1" superblocks
of md and what is the differnce between them? Is it merely
some version of kernel md driver ?
In case it is so - is there a way to know which is
the version of the md superblocks which is in use in my kernel ?

I see that in drivers/md/md.c
there is an array of super_type with 2 elements,
the name	of the first is  "0.90.0",and the name of the second
is "md-1".

when running :
mdadm --detail /dev/md0
I see:
/dev/md0:
        Version : 00.90.01
			..
			
is this "Version" field is the superblock type ?


Regards,
MR
