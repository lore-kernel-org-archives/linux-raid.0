From: "Kevin P. Fleming" <kpfleming@starnetworks.us>
Subject: Re: error opening /dev/md2: No such file or directory
Date: Thu, 02 Dec 2004 11:30:50 -0700
Message-ID: <41AF5F5A.4090709@starnetworks.us>
References: <conlcb$14p$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <conlcb$14p$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Bowes wrote:

> # mdadm --create /dev/md2 --level=1 --raid-devices=2 /dev/sdc1 missing
> mdadm: error opening /dev/md2: No such file or directory

This is a side-effect of the way that the MD driver operates in a 
dynamic /dev environment. mdadm needs the /dev/mdX node to be available 
to be able to manipulate the array, but it doesn't exist until the array 
has been created. Catch-22.

At some point mdadm and the MD driver need a new communication method 
that uses a common device node for all arrays, but that won't happen soon.

In the meantime, you can manually create /dev/mdX nodes with mknod, just 
as you would have done before. Once the array is created, if you have it 
set to auto-start (using 0xfd partition types), it the device node will 
automatically appear when you boot your system. If you don't have it set 
to auto-start, you'll have to add the "mknod" command to your system 
startup scripts before trying to start the array directly.
