From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Relabeling UUID
Date: Wed, 13 Dec 2006 16:37:26 -0500
Message-ID: <45807296.2040601@tmr.com>
References: <457F3BAD.6060206@tmr.com>	<17791.18766.36228.208220@cse.unsw.edu.au>	<457F92D9.6020105@tmr.com> <17791.56072.269281.604820@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17791.56072.269281.604820@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday December 13, davidsen@tmr.com wrote:
>   
>> Before I tell you that doesn't work, could you provide a complete 
>> command line you expect to work rather than just one argument? Showing 
>> the array designator and the location of the actual new UUID to use? We 
>> think we have tried every combination of array name or array components 
>> in every order, and other than a fine collection of error messages have 
>> not had any luck.
>>
>> We would look at the example but found none.
>>     
>
> Hmmm.... yes ..... well.....
>
> # mdadm -V
> mdadm - v2.5.6 - 9 November 2006
> # mdadm -Dvb /dev/md1
> ARRAY /dev/md1 level=raid5 num-devices=3 UUID=9f148061:9b31aaf3:1727f0dc:460ad0c5
>    devices=/dev/sdc,/dev/sdd,/dev/sde
> # mdadm -S /dev/md1
> mdadm: stopped /dev/md1
> # mdadm -Aamd /dev/md1 --update=uuid --uuid=12345678:9abcdef0:fedcba98:76543210 /dev/sdc /dev/sdd /dev/sde
> mdadm: Could not update uuid on /dev/sdc.
> mdadm: Could not update uuid on /dev/sdd.
> mdadm: Could not update uuid on /dev/sde.
> mdadm: /dev/md1 has been started with 3 drives.
> # mdadm -Dvb /dev/md1
> ARRAY /dev/md1 level=raid5 num-devices=3 UUID=12345678:9abcdef0:fedcba98:76543210
>    devices=/dev/sdc,/dev/sdd,/dev/sde
>
> Ok, so there is an error message, but it does actually change the
> uuid.
>   
I guess that in testing I should have checked to see if it worked, 
but... I don't feel so dumb for not finding that now. Thanks!
> In Assemble.c, 
> 			if (strcmp(update, "uuid")==0 &&
> 			    ident->bitmap_fd)
> 				if (bitmap_update_uuid(ident->bitmap_fd, info.uuid) != 0)
> 					fprintf(stderr, Name ": Could not update uuid on %s.\n",
> 						devname);
>
> should be
> 			if (strcmp(update, "uuid")==0 &&
> 			    ident->bitmap_fd >= 0)
> 				if (bitmap_update_uuid(ident->bitmap_fd, info.uuid) != 0)
> 					fprintf(stderr, Name ": Could not update uuid on %s.\n",
> 						devname);
>
> That will get rid of the error message.
> I guess I should add '--update=uuid' to the regression test suite.
>   
Prevents PITA users like me from whining. ;-)
> Note that you need to use something other than the uuid to identify
> the array.  A list of devices is the most obvious choice.
>   
For something few people do that's certainly acceptable.

That said, it certainly would be the most convenient solution to allow 
the uuid= option on the create in the first place. But this is a corner 
case, so unless I find that I want to code it myself (may) other 
solutions are fine.
> Patches to the man page to add useful examples are always welcome.
Hint taken.

Thanks again for clarifying this, I assumed the error message meant I 
had it wrong, and didn't check to see if it actually worked.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

