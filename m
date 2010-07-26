From: Keld Simonsen <keld@keldix.com>
Subject: Re: raid1 performance
Date: Mon, 26 Jul 2010 12:24:06 +0200
Message-ID: <20100726102406.GA8415@rap.rap.dk>
References: <443220.14357.qm@web28508.mail.ukl.yahoo.com>
 <20100725211926.7547c12e@natsu>
 <23123.42111.qm@web28503.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <23123.42111.qm@web28503.mail.ukl.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marco <jjletho67-diar@yahoo.it>
Cc: Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 26, 2010 at 09:37:20AM +0000, Marco wrote:
> 
> 
> >> doing a simple performance tests i obtained some very unexpected results: if
> >> i issue hdparm -t /dev/md2 i obtain 61 - 65 MB/s while issuing the same test 
> >> directly on the partitions which compose md2 (/dev/sda3 and /dev/sdb3) i
> >> obtain 84 - 87 MB/s. I didn't expect a so big difference between md2 and one
> >> of its member. What can cause  this difference ? 
> >
> >Maybe their read-ahead settings are different?
> >Check out "blockdev --getra /dev/md2", and compare that with the same
> >setting of the member disks. You can experiment with changing it by using
> >"--setra" as well.
> 
> Hi Roman,
> thank you for your hint, I verified the read-ahead settings and they are the 
> same for all the block devices involved in the test: the value is 256 for all 
> /dev/sd?? and for all /dev/md?
> there should be something else which is influencing  raid 1 performance.
> Have someone of you ever had a similar issue ?

Did you try:

# Set read-ahead.
echo "Setting read-ahead to 64 MiB for /dev/md3"
blockdev --setra 65536 /dev/md3

Best regards
keld
