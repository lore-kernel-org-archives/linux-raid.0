From: AndyLiebman@aol.com
Subject: Re: mdadm segfault
Date: Thu, 16 Dec 2004 18:45:49 EST
Message-ID: <a3.692fafd2.2ef3782d@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mjstumpf@pobox.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I also found that 1.8.1 was segfaulting with Mandrake 10. I figured the 
problem was that I had created the RAID 0 array with 1.5 or 1.6 (don't remember 
which). I had all the drives from the array, but it didn't find them to Assemble 
them. 

From a cursory glance at the info about 1.8.1, quite a few things changed. 
Maybe not just a "dot release" from 1.8.0. I sort of installed it by accident -- 
I meant to install 1.8.0 -- which for me is working great. 

Andy Liebman

>In a message dated 12/16/2004 5:36:21 PM Eastern Standard Time, 
>mjstumpf@pobox.com writes:
>mdadm 1.8.1 is segfaulting on red hat linux 7.3.  Kernel is 2.4.18smp5.  
>Happened when I try to assemble a 3 drive array with only 2 drives.
>
>Not important to me; I just downgraded to 1.2.0 and it worked like a 
>champ, but I figured I'd throw that out there as an FYI.
