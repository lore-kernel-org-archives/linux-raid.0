From: Veedar Hokstadt <veedar@gmail.com>
Subject: Re: Is a raid0 512 byte chunk size possible? Or is it just too small?
Date: Sat, 7 Sep 2013 15:57:39 -0400
Message-ID: <CANb3qHfRh2scH+ykO+H6okEFe3AU89n+PT4+sx79ypStAJUufg@mail.gmail.com>
References: <CANb3qHcczcKrCOPWy7MfY2aP_0V2c5KkQa6zzm5f1J7Qx20W8w@mail.gmail.com>
	<52210FAB.7060606@hardwarefreak.com>
	<CALFpzo7sZgjrZbfT=1uT3UMWwA7TG6pBXsj4f+oxRAfwuvWZ9w@mail.gmail.com>
	<CANb3qHfJ=5T6Oa0NgPdLsDhdjj4wMPorRtkZjwDjdh14oKjcsw@mail.gmail.com>
	<20130831131009.4a1dfaad@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130831131009.4a1dfaad@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Marcus Sorensen <shadowsor@gmail.com>, stan@hardwarefreak.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Just to close this out. The making a 4TB image file of the raid0 was
not feasible for me so I ended up using a commercial raid recovery app
that could handle the 512 byte chunk.

Thanks for your help.  -V

On 8/31/13, Roman Mamedov <rm@romanrm.net> wrote:
> On Sat, 31 Aug 2013 01:05:44 -0400
> Veedar Hokstadt <veedar@gmail.com> wrote:
>
>> I am totally aware of the complications involved but if I can somehow
>> build a raid0 / chunk 512B array with mdadm using the raw Lacie dives
>> then I can take it from there to recover the data.
>
> You can write a simple program to read in chunks of 512 bytes from one
> drive,
> then from the other, piece this together and write to some third file. Here
> is
> something quick that I modified from a tool I already had. Even though it's
> doing the tight loop in PHP, it seems to do about 100 MB/sec reading from
> two
> SATA drives and writing to a file on a RAID6 in my system.
>
> --- merge.php ---
>
> #!/usr/bin/php
> <?php
>   $f = array();
>   array_shift($argv);
>   foreach($argv as $arg) {
>     if(($f[] = @fopen($arg, "rb"))===false) die("Unable to open file
> $arg.\n");
>   }
>   while(@$feof_cnt<2) {
>     $feof_cnt=0;
>     foreach($f as $file) {
>       print(fread($file, 512));
>       if(feof($file))$feof_cnt++;
>     }
>   }
> ?>
>
> ---
>
> Usage: ./merge.php /dev/sda /dev/sdb > image.img
>
> And you will need somewhere to store this image.img that's has the free
> space
> to fit the size of sda+sdb. Also check that you specify the drives in the
> proper order (only 2 tries, really).
>
> --
> With respect,
> Roman
>
