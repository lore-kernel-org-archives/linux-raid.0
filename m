From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] RAID-6 check standalone md device
Date: Tue, 5 Apr 2011 09:01:13 +1000
Message-ID: <20110405090113.5454b403@notabene.brown>
References: <20110221204551.GA15675@lazy.lzy>
	<20110321140244.2314b4b4@notabene.brown>
	<20110321104007.GA15379@lazy.lzy>
	<20110321220457.29d52f5c@notabene.brown>
	<20110321115440.GA15635@lazy.lzy>
	<20110322095905.737fb1d5@notabene.brown>
	<20110331185346.GA5210@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110331185346.GA5210@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 31 Mar 2011 20:53:46 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi Neil,
> 
> please find below the promised patch for the
> RAID-6 check, which allows to pass only the
> MD device, start and length.
> The three parameters are mandatory.
> 
> All necessary information is collected using
> the "sysfs_read()" call.
> Furthermore, if "length" is "0", then the check
> is performed until the end of the array.
> 
> The "Makefile" needed modifications too (as done
> previously) in order to link "sysfs.c".
> 
> Some checks are done, for example if the md device
> is really a RAID-6. Nevertheless I guess it is not
> bullet proof...
> 
> Next patch will include the "suspend" action.
> My idea is to do it "per stripe", please let me
> know if you've some better options.

Hi,
 I've applied this patch after some minor clean ups (indenting mostly).
 I rearranged some code first so that we don't need to link all all of the
 rest of mdadm - just a few 'library-style' files.

 I'm not sure about the loop:
>  
> +	comp = info->devs;
>  	for (i=0; i<raid_disks; i++) {
> -		char *p;
> -		p = strchr(argv[6+i], ':');
> -
> -		if(p != NULL) {
> -			*p++ = '\0';
> -			offsets[i] = atoll(p) * 512;
> -		}
> -		fds[i] = open(argv[6+i], O_RDWR);
> -		if (fds[i] < 0) {
> -			perror(argv[6+i]);
> -			fprintf(stderr,"test_stripe: cannot open %s.\n", argv[6+i]);
> +		int disk_slot = comp->disk.raid_disk;
> +		disk_name[disk_slot] = map_dev(comp->disk.major, comp->disk.minor, 0);
> +		offsets[disk_slot] = comp->data_offset * 512;
> +		fds[disk_slot] = open(disk_name[disk_slot], O_RDWR);
> +		if (fds[disk_slot] < 0) {
> +			perror(disk_name[disk_slot]);
> +			fprintf(stderr,"%s: cannot open %s\n", prg, disk_name[disk_slot]);
>  			exit(3);
>  		}
> +
> +		comp = comp->next;
>  	}


The 'info->devs' list could include spare devices mixed in with the other
devices.  So the 'for' loop should go to the end of list list, and we should
ignore devices which are not active..
So you should probably fix this.

You will be able to find the applied patch in my 'master' branch shortly.

Thanks,
NeilBrown

