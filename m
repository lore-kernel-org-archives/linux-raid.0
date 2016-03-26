From: Sebastian Roesner <sroesner-kernelorg@roesner-online.de>
Subject: Re: [BUG] NULL pointer in raid1_make_request passed to bio_trim when
 adding md as bcache caching dev
Date: Sat, 26 Mar 2016 17:46:16 +0100
Message-ID: <56F6BCD8.70504@roesner-online.de>
References: <56F4058B.1030309@roesner-online.de>
 <alpine.LRH.2.11.1603250126110.13440@mail.ewheeler.net>
 <alpine.LRH.2.11.1603250416030.13440@mail.ewheeler.net>
 <56F54712.6090202@roesner-online.de>
 <alpine.LRH.2.11.1603251954220.13440@mail.ewheeler.net>
 <CACVXFVO7ARehcQHvBuRoVHZhc0BgA5kKxaPQTqMT7Y=4Ca6urw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <CACVXFVO7ARehcQHvBuRoVHZhc0BgA5kKxaPQTqMT7Y=4Ca6urw@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>, Eric Wheeler <bcache@lists.ewheeler.net>
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, Ming Lin <mlin@kernel.org>, Vlad-Cosmin Miu <miuvlad@gmail.com>, rjones@redhat.com, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-raid.ids

Hello Ming, Eric,

Am 26.03.2016 um 16:40 schrieb Ming Lei:
>  From the trace, looks the bio returned from bio_clone_mddev() is NULL,
> and maybe the source bio is buggy, something like the attached patch
> might be helpful, could you apply the attached debug patch, reproduce
> and post the log?

I was able to reproduce it on a non-productive system, but only after 
copying the bcache superblocks/partition starts from the original 
system, with new created ones it worked fine.

Full trace and check_bio output can be found here:

http://pastebin.com/ngvGGHBZ

Sebastian
