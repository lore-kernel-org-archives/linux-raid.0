From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: raid1-diseaster on reboot: old version overwrites new version
Date: Sat, 02 Apr 2005 09:35:54 -0800
Message-ID: <424ED7FA.4050007@nsr500.net>
References: <424EBDB7.2000106@goldfisch.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <424EBDB7.2000106@goldfisch.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



peter pilsl wrote:
> The only explantion to me is, that I had the wrong entry in my 
> lilo.conf. I had root=/dev/hda6 there instead of root=/dev/md2
> So maybe root was always mounted as /dev/hda6 and never as /dev/md2, 
> which was started, but never had any data written to it. Is this a 
> possible explanation?

No.  The lilo.conf entry just tells the kernel where root is located.

Can you publish your /etc/fstab and fdisk -l output?

-- 

