From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH] RAID-6 check standalone md device
Date: Tue, 5 Apr 2011 21:56:35 +0200
Message-ID: <20110405195635.GA2896@lazy.lzy>
References: <20110221204551.GA15675@lazy.lzy>
 <20110321140244.2314b4b4@notabene.brown>
 <20110321104007.GA15379@lazy.lzy>
 <20110321220457.29d52f5c@notabene.brown>
 <20110321115440.GA15635@lazy.lzy>
 <20110322095905.737fb1d5@notabene.brown>
 <20110331185346.GA5210@lazy.lzy>
 <20110405090113.5454b403@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110405090113.5454b403@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Tue, Apr 05, 2011 at 09:01:13AM +1000, NeilBrown wrote:
> On Thu, 31 Mar 2011 20:53:46 +0200 Piergiorgio Sartor
> <piergiorgio.sartor@nexgo.de> wrote:
> 
> > Hi Neil,
> > 
> > please find below the promised patch for the
> > RAID-6 check, which allows to pass only the
> > MD device, start and length.
> > The three parameters are mandatory.
> > 
> > All necessary information is collected using
> > the "sysfs_read()" call.
> > Furthermore, if "length" is "0", then the check
> > is performed until the end of the array.
> > 
> > The "Makefile" needed modifications too (as done
> > previously) in order to link "sysfs.c".
> > 
> > Some checks are done, for example if the md device
> > is really a RAID-6. Nevertheless I guess it is not
> > bullet proof...
> > 
> > Next patch will include the "suspend" action.
> > My idea is to do it "per stripe", please let me
> > know if you've some better options.
> 
> Hi,
>  I've applied this patch after some minor clean ups (indenting mostly).
>  I rearranged some code first so that we don't need to link all all of the
>  rest of mdadm - just a few 'library-style' files.
> 
>  I'm not sure about the loop:
> >  
> > +	comp = info->devs;
> >  	for (i=0; i<raid_disks; i++) {
> > -		char *p;
> > -		p = strchr(argv[6+i], ':');
> > -
> > -		if(p != NULL) {
> > -			*p++ = '\0';
> > -			offsets[i] = atoll(p) * 512;
> > -		}
> > -		fds[i] = open(argv[6+i], O_RDWR);
> > -		if (fds[i] < 0) {
> > -			perror(argv[6+i]);
> > -			fprintf(stderr,"test_stripe: cannot open %s.\n", argv[6+i]);
> > +		int disk_slot = comp->disk.raid_disk;
> > +		disk_name[disk_slot] = map_dev(comp->disk.major, comp->disk.minor, 0);
> > +		offsets[disk_slot] = comp->data_offset * 512;
> > +		fds[disk_slot] = open(disk_name[disk_slot], O_RDWR);
> > +		if (fds[disk_slot] < 0) {
> > +			perror(disk_name[disk_slot]);
> > +			fprintf(stderr,"%s: cannot open %s\n", prg, disk_name[disk_slot]);
> >  			exit(3);
> >  		}
> > +
> > +		comp = comp->next;
> >  	}
> 
> 
> The 'info->devs' list could include spare devices mixed in with the other
> devices.  So the 'for' loop should go to the end of list list, and we should
> ignore devices which are not active..
> So you should probably fix this.

thanks for the information, that's actually very
important.

I'll try to provide a fix patch in then next days.

> You will be able to find the applied patch in my 'master' branch shortly.

Good!

Thanks again,

bye,

pg
 
> Thanks,
> NeilBrown
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
