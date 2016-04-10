From: Sebastian Roesner <sroesner-kernelorg@roesner-online.de>
Subject: Re: [BUG] NULL pointer in raid1_make_request passed to bio_trim when
 adding md as bcache caching dev
Date: Sun, 10 Apr 2016 20:01:30 +0200
Message-ID: <570A94FA.7040906@roesner-online.de>
References: <56F4058B.1030309@roesner-online.de>
 <alpine.LRH.2.11.1603250126110.13440@mail.ewheeler.net>
 <alpine.LRH.2.11.1603250416030.13440@mail.ewheeler.net>
 <56F54712.6090202@roesner-online.de>
 <alpine.LRH.2.11.1603251954220.13440@mail.ewheeler.net>
 <CACVXFVO7ARehcQHvBuRoVHZhc0BgA5kKxaPQTqMT7Y=4Ca6urw@mail.gmail.com>
 <56F6BCD8.70504@roesner-online.de> <20160328181059.GA83819@kernel.org>
 <alpine.LRH.2.11.1604011812170.5949@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1604011812170.5949@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>, Shaohua Li <shli@kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, Ming Lin <mlin@kernel.org>, Vlad-Cosmin Miu <miuvlad@gmail.com>, rjones@redhat.com, Kent Overstreet <kent.overstreet@gmail.com>, jmoyer@redhat.com, axboe@fb.com
List-Id: linux-raid.ids

Hello Eric, Shaohua,

Am 01.04.2016 um 20:14 schrieb Eric Wheeler:
 > Hey Sebastian,
 >
 > Have you had a chance to test the patch below from Shaohua Li?

I just tried the patch and it did not crash anymore.

Sebastian
