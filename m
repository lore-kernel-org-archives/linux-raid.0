From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/4] mdadm: bad block support for external metadata - initialization
Date: Wed, 26 Oct 2016 14:00:47 -0400
Message-ID: <wrfj4m3zkn1s.fsf@redhat.com>
References: <1476968626-19233-1-git-send-email-tomasz.majchrzak@intel.com>
        <20161020140220.GB17867@www5.open-std.org>
        <20161020142611.GA23120@proton.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161020142611.GA23120@proton.igk.intel.com> (Tomasz Majchrzak's
        message of "Thu, 20 Oct 2016 16:26:11 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: keld@keldix.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> I cannot see how badblocks program is related to this patch. It is a generic
> code for bad blocks support in IMSM metadata. It introduces 64-bit value for
> sector address, the same size as in kernel. All it does is syncing kernel bad
> block list with raid metadata.
>
> Tomek

I was waiting for this response, but you cut me off the CC list so
missed it.

In this case I'll go ahead and apply these patches to mdadm.

Cheers,
Jes

>
> On Thu, Oct 20, 2016 at 04:02:20PM +0200, keld@keldix.com wrote:
>> Is this safe for 2TB+ arrays?
>> I think the badblocks program does not handle 2TB+ partitions?
>> 
>> best regards
>> Keld
>> 
>> Best regards
>> Keld
>> 
>> On Thu, Oct 20, 2016 at 03:03:46PM +0200, Tomasz Majchrzak wrote:
>> > If metadata handler provides support for bad blocks, tell md by writing
>> > 'external_bbl' to rdev state file (both on create and assemble),
>> > followed by a list of known bad blocks written via sysfs 'bad_blocks'
>> > file.
>> > 
>> > Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
>> > Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>> > ---
>> >  mdadm.h | 13 +++++++++++++
>> >  sysfs.c | 29 ++++++++++++++++++++++++++++-
>> >  2 files changed, 41 insertions(+), 1 deletion(-)
>> > 
>> > diff --git a/mdadm.h b/mdadm.h
>> > index 0516c82..5156ea4 100755
>> > --- a/mdadm.h
>> > +++ b/mdadm.h
>> > @@ -237,6 +237,17 @@ struct dlm_lksb {
>> >  
>> >  extern const char Name[];
>> >  
>> > +struct md_bb_entry {
>> > +	unsigned long long sector;
>> > +	int length;
>> > +};
>> > +
>> > +struct md_bb {
>> > +	int supported;
>> > +	int count;
>> > +	struct md_bb_entry *entries;
>> > +};
>> > +
>> >  /* general information that might be extracted from a superblock */
>> >  struct mdinfo {
>> >  	mdu_array_info_t	array;
>> > @@ -311,6 +322,8 @@ struct mdinfo {
>> >  
>> >  	/* info read from sysfs */
>> >  	char		sysfs_array_state[20];
>> > +
>> > +	struct md_bb bb;
>> >  };
>> >  
>> >  struct createinfo {
>> > diff --git a/sysfs.c b/sysfs.c
>> > index d28e21a..c7a8e66 100644
>> > --- a/sysfs.c
>> > +++ b/sysfs.c
>> > @@ -50,8 +50,12 @@ void sysfs_free(struct mdinfo *sra)
>> >  		while (sra->devs) {
>> >  			struct mdinfo *d = sra->devs;
>> >  			sra->devs = d->next;
>> > +			if (d->bb.entries)
>> > +				free(d->bb.entries);
>> >  			free(d);
>> >  		}
>> > +		if (sra->bb.entries)
>> > +			free(sra->bb.entries);
>> >  		free(sra);
>> >  		sra = sra2;
>> >  	}
>> > @@ -259,7 +263,7 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
>> >  		dbase = base + strlen(base);
>> >  		*dbase++ = '/';
>> >  
>> > -		dev = xmalloc(sizeof(*dev));
>> > +		dev = xcalloc(1, sizeof(*dev));
>> >  
>> >  		/* Always get slot, major, minor */
>> >  		strcpy(dbase, "slot");
>> > @@ -687,6 +691,7 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
>> >  	char nm[PATH_MAX];
>> >  	char *dname;
>> >  	int rv;
>> > +	int i;
>> >  
>> >  	sprintf(dv, "%d:%d", sd->disk.major, sd->disk.minor);
>> >  	rv = sysfs_set_str(sra, NULL, "new_dev", dv);
>> > @@ -718,6 +723,28 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
>> >  		if (resume)
>> >  			sysfs_set_num(sra, sd, "recovery_start", sd->recovery_start);
>> >  	}
>> > +	if (sd->bb.supported) {
>> > +		if (sysfs_set_str(sra, sd, "state", "external_bbl")) {
>> > +			/*
>> > +			 * backward compatibility - if kernel doesn't support
>> > +			 * bad blocks for external metadata, let it continue
>> > +			 * as long as there are none known so far
>> > +			 */
>> > +			if (sd->bb.count) {
>> > +				pr_err("The kernel has no support for bad blocks in external metadata\n");
>> > +				return -1;
>> > +			}
>> > +		}
>> > +
>> > +		for (i = 0; i < sd->bb.count; i++) {
>> > +			char s[30];
>> > +			const struct md_bb_entry *entry = &sd->bb.entries[i];
>> > +
>> > +			snprintf(s, sizeof(s) - 1, "%llu %d\n", entry->sector,
>> > +				 entry->length);
>> > +			rv |= sysfs_set_str(sra, sd, "bad_blocks", s);
>> > +		}
>> > +	}
>> >  	return rv;
>> >  }
>> >  
>> > -- 
>> > 1.8.3.1
>> > 
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
