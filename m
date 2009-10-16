From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Disappointing RAID10 Performance
Date: Fri, 16 Oct 2009 23:27:49 +0200
Message-ID: <20091016212749.GA997@rap.rap.dk>
References: <364346.70897.qm@web38808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <364346.70897.qm@web38808.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 16, 2009 at 10:32:14AM -0700, adfas asd wrote:
> I was hoping to get better performance with RAID10 than from the raw disks, but that's turned out to not be the case.  Experimenting with the readahead buffer I get these bandwidths with the following command:
> # time dd if={somelarge}.iso of=/dev/null bs={readahead size}
> 
> /dev/sd?
>  1024 71.3 MB/s
>  2048 71.2 MB/s
>  4096 77.7 MB/s
>  8192 69.4 MB/s
>  16384 76.6 MB/s
> 
> /dev/md2
>  1024  67.1
>  2048  69.1
>  4096  75.7
>  8192  64.9
>  16384 69.0
> 
> Using RAID10offset2 on 2 WD 2TB drives, and always the same input file.
> 
> Why would RAID10 performance be -poorer-? 
> If it weren't for mirroring, this wouldn't be worth it.

try with layout=far - it is good for reading big files, maybe a factor 2
faster than layout=offset.

More on performance:
http://linux-raid.osdl.org/index.php/Performance

Best regards
keld
