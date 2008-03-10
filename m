From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: LVM performance
Date: Mon, 10 Mar 2008 13:59:59 +1300
Message-ID: <47D4880F.8050309@sauce.co.nz>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>	<18360.8065.335494.142060@tree.ty.sabi.co.UK>	<20080217074526.29d3c5c5@hardcode42.net>	<20080218062604.05ae4821@szpak>	<aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com>	<20080218154203.6e2d1483@szpak>	<47BB30DF.1080006@student.tuwien.ac.at>	<18364.6868.854623.613958@tree.ty.sabi.co.UK>	<47BED119.4070000@student.tuwien.ac.at> <18384.63840.605334.155518@tree.ty.sabi.co.UK> <47D440D6.90509@student.tuwien.ac.at> <8D0FC34E-F0B0-4BAF-A466-2C8BC439E7FF@it-loops.com> <47D47264.4070404@student.tuwien.ac.at> <47D4819E.5010807@sauce.co.nz> <7F70AB26-25B7-4127-A3A9-62D104B7A80F@it-loops.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7F70AB26-25B7-4127-A3A9-62D104B7A80F@it-loops.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Guntsche wrote:

> That's true but only if you create a XFS filesystem on the md device  
> directly. If LVM is in between mkfs.xfs cannot figure it out and you  
> have to specify the values yourself.

I wondered about that after I wrote and found this in the mkfs.xfs man page:

"sw=value

suboption is an alternative to using swidth.  The sw suboption is used 
to specify the  stripe  width for  a  RAID  device or striped logical 
volume. The value is expressed as a multiplier of the stripe unit, 
usually the same as the number of stripe members in the logical volume 
configuration, or  data disks in a RAID device.

When a filesystem is created on a logical volume device, mkfs.xfs will 
automatically query the logical volume for appropriate sunit and swidth 
values."

So perhaps it'll do the same on LVM?

Regards,

Richard
