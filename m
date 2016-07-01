From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 00/12] gendisk: Generate uevent after attribute available
Date: Thu, 30 Jun 2016 18:29:31 -0700
Message-ID: <CAA9_cmeb99S+UoZ7A-4HHmT_rFRgnSaBX=YszEk8+4_=n9cOnA@mail.gmail.com>
References: <20160630015953.6888-1-famz@redhat.com> <20160630062442.GA19761@infradead.org>
 <20160630063554.GE23296@ad.usersys.redhat.com> <20160630063839.GA17205@infradead.org>
 <20160701010113.GB10122@ad.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20160701010113.GB10122@ad.usersys.redhat.com>
Sender: linux-mmc-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Jens Axboe <axboe@kernel.dk>, "Ed L. Cashin" <ed.cashin@acm.org>, Jiri Kosina <jikos@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Shaohua Li <shli@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Keith Busch <keith.busch@intel.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-block@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-raid <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.ker>
List-Id: linux-raid.ids

On Thu, Jun 30, 2016 at 6:01 PM, Fam Zheng <famz@redhat.com> wrote:
> On Wed, 06/29 23:38, Christoph Hellwig wrote:
>> On Thu, Jun 30, 2016 at 02:35:54PM +0800, Fam Zheng wrote:
>> > also more code and less flexible IMO.  For example, we need at least two
>> > variants, for attribute_group and device_attribute separately, right?
>>
>> Yes, or maybe just a calling convention that just passes both.
>
> OK, I can look into that, but I'm not sure about the error handling. Currently
> add_disk returns void, do you have any plan on that too? should I change it in
> v3 (to at least return the attribute creation failure)?

I think we should only support a "groups" interface to
device_add_disk() and convert all the drivers that currently do
device_create_file() after add_disk() to pass in a group list instead.
That way we follow the expectation that the only way to get an
attribute for a device to show up before KOBJ_ADD, is to define a
group:

From Documentation/driver-model/device.txt:
    As explained in Documentation/kobject.txt, device attributes must be be
    created before the KOBJ_ADD uevent is generated. The only way to realize
    that is by defining an attribute group.

Let's defer the return value fixing for now.

You can find the pending device_add_disk() patches in the nvdimm
patchwork starting with "block: introduce device_add_disk()"

https://patchwork.kernel.org/project/linux-nvdimm/list/
