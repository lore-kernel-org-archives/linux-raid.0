From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH v2 00/12] gendisk: Generate uevent after attribute
	available
Date: Thu, 30 Jun 2016 14:35:54 +0800
Message-ID: <20160630063554.GE23296@ad.usersys.redhat.com>
References: <20160630015953.6888-1-famz@redhat.com>
	<20160630062442.GA19761@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20160630062442.GA19761@infradead.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org, Keith Busch <keith.busch@intel.com>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Shaohua Li <shli@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Jiri Kosina <jikos@kernel.org>, linux-block@vger.kernel.org, dan.j.williams@intel.com, "Ed L. Cashin" <ed.cashin@acm.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, Brian Norris <computersforpeace@gmail.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-raid.ids

On Wed, 06/29 23:24, Christoph Hellwig wrote:
> On Thu, Jun 30, 2016 at 09:59:41AM +0800, Fam Zheng wrote:
> > Documentation/kobject.txt:
> > > Use the KOBJ_ADD action for when the kobject is first added to the kernel.
> > > This should be done only after any attributes or children of the kobject
> > > have been initialized properly, as userspace will instantly start to look
> > > for them when this call happens.
> > 
> > Unfortunately it seems impossible to fix this generally without touching the
> > offending callers.  The approach I'm proposing here is adding a flag to
> > suppress uevent in add_disk(), which is patch 1, then in later patches, convert
> > any caller to only trigger the uevent when attributes are added.
> 
> We (or rather Dan) is touching most add_disk callers anyway for the
> driverfs_dev removal.  Let's just pass the array of attributes to
> a disk_add variant and solve the issue for real.

I thought about that. Its usage is more compact compared to this series, but is
also more code and less flexible IMO.  For example, we need at least two
variants, for attribute_group and device_attribute separately, right?

Fam
