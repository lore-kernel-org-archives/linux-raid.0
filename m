From: Brad Dameron <brad@seatab.com>
Subject: Re: raid'ing problems
Date: Fri, 21 Oct 2005 09:01:05 -0700
Message-ID: <1129910465.14614.2.camel@dhcpc226.office.pivotlink.com>
References: <1129899043.32525.4.camel@plauda5.rx30.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1129899043.32525.4.camel@plauda5.rx30.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2005-10-21 at 08:50 -0400, Peter Lauda wrote:
> If anyone is listening....
> 
> I have read the howto's and all the FAQ's I can find. I am trying to do
> the following and having zero success:
> 
> An installed system needs to have a second disk setup with the first as
> a raid 1 set. 
> 
> I have been able to boot from a CD and create the md0 md1 and md2
> devices. I cannot however, get any of these to mount afterwards. I
> assume that mount doesn't know what type of fs these are and I'm not
> seeing anything in the docs about what type I can use. 
> 
> Eventually this raid set needs to be able to boot. We use grub as the
> boot loader. If anyone has done this or knows how and can offer any
> assistance I thank you in advance.
> 
> We are using 2.4.29 kernel in a home rolled package but have both
> raidtools and mdadm tools available.
> 
> Cheers!
> --p

Did you format the partitions after you created them?

mkfs.ext3 /dev/md0

And read this link for your other question.

http://www.linuxsa.org.au/mailing-list/2003-07/1270.html

Googled in 0.36 seconds.

Brad Dameron
SeaTab Software
www.seatab.com



