From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: Re: [PATCH 1/8] imsm: parse bad block log in metadata on startup
Date: Tue, 29 Nov 2016 14:17:21 +0100
Message-ID: <20161129131721.GA31745@proton.igk.intel.com>
References: <1477925454-16809-1-git-send-email-tomasz.majchrzak@intel.com>
 <wrfjh977mqnt.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <wrfjh977mqnt.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 16, 2016 at 09:43:18AM -0500, Jes Sorensen wrote:
> Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> > Always allocate memory for all log entries to avoid a need for memory
> > allocation when monitor requests to record a bad block.
> >
> > Also some extra checks added to make static code analyzer happy.
> >
> > Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> > ---
> >  super-intel.c | 158 +++++++++++++++++++++++++++++++++++++++++-----------------
> >  1 file changed, 112 insertions(+), 46 deletions(-)
> 
> > @@ -785,6 +787,92 @@ static struct imsm_dev *get_imsm_dev(struct intel_super *super, __u8 index)
> >  	return NULL;
> >  }
> >  
> > +#if BYTE_ORDER == LITTLE_ENDIAN
> > +static inline unsigned long long __le48_to_cpu(const struct bbm_log_block_addr
> > +					       *addr)
> > +{
> > +	return ((((__u64)addr->dw1) << 16) | addr->w1);
> > +}
> > +
> > +static inline struct bbm_log_block_addr __cpu_to_le48(unsigned long long sec)
> > +{
> > +	struct bbm_log_block_addr addr;
> > +
> > +	addr.w1 =  (__u16)(sec & 0xFFFF);
> > +	addr.dw1 = (__u32)((sec >> 16) & 0xFFFFFFFF);
> > +	return addr;
> > +}
> 
> Again, 0xffff/0xffffffff
> 
> > +#elif BYTE_ORDER == BIG_ENDIAN
> > +static inline unsigned long long __le48_to_cpu(const struct bbm_log_block_addr
> > +					       *addr)
> > +{
> > +	return ((((__u64)__le32_to_cpu(addr->dw1)) << 16) |
> > +		__le16_to_cpu(addr->w1));
> > +}
> > +
> > +static inline struct bbm_log_block_addr __cpu_to_le48(unsigned long long sec)
> > +{
> > +	struct bbm_log_block_addr addr;
> > +
> > +	addr.w1 =  __cpu_to_le16((__u16)(sec & 0xFFFF));
> > +	addr.dw1 = __cpu_to_le32((__u32)(sec >> 16) & 0xFFFFFFFF);
> > +	return addr;
> > +}
> 
> Given that __cpu_to_le*()/__le*_to_cpu*() are no-ops on little-endian,
> you don't really need two versions of these. The big-endian version
> should suffice for both, which makes it far less cluttered. Unless I got
> something wrong here of course.
> 
> > +#else
> > +#  error "unknown endianness."
> > +#endif
> > +

Hi Jes,

Internally IMSM metadata stores bad block address as 48-bit little-endian
value. Those functions provide conversion from/to a structure consisting of
2 fields (32 + 16 bits). For little-endian CPU it's just about shifting bits,
for big-endian CPU bits have to be swapped. IMSM is not available on
big-endian platforms so big-endian implementation is provided for
completeness. I haven't changed it in my latest patch.

Regards,

Tomek
