From: Mike Hardy <mhardy@h3c.com>
Subject: Re: RAID 1 on a server with possible mad mobo
Date: Tue, 08 Mar 2005 18:14:07 -0800
Message-ID: <422E5BEF.9040706@h3c.com>
References: <bbfa52890503081019478cb6cf@mail.gmail.com>	 <422DF363.6090105@steeleye.com> <bbfa528905030816484108fa7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <bbfa528905030816484108fa7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Colin McDonald <ce.mcdonald@gmail.com>
Cc: Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Colin McDonald wrote:

  Is it a bad idea to write the grub to a software mirror. Is it written
> to a specific disk when this is done?

The "Software Raid and Grub HOW-TO"

http://lists.us.dell.com/pipermail/linux-poweredge/2003-July/014331.html

I use grub+raid1 on the root drive of a number of machines, but you do 
have to be careful as its my understanding its not raid aware, and 
"picks" a drive, whereas lilo was raid-aware and wrote the boot sector 
on all components.

After following the directions at the link above, I've been able to boot 
the machine off each component (during failure testing), so the 
directions appear to work, to me.

-Mike
