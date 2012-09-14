From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: Small short question
Date: Fri, 14 Sep 2012 22:19:26 +0200
Message-ID: <5053914E.1040803@schinagl.nl>
References: <5030F07F.7000303@schinagl.nl> <504CFA7B.7090606@schinagl.nl> <20120910090829.19100cdf@notabene.brown> <504DA85C.6080000@schinagl.nl> <20120911161622.0b0fcf8c@notabene.brown> <505301E1.10707@schinagl.nl> <50531A52.7060205@schinagl.nl> <20563.24213.638530.461182@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20563.24213.638530.461182@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14-09-12 18:43, Peter Grandi wrote:
>> Since I had only one valid device to check with etc, I assume
>> that if fsck -n -f /dev/md2 runs sucessfully, it is 100% safe
>> to assume the array is perfectly healthy?
> If the filesystem used supports both metadata and data checksums
> and its 'fsck -f' does verify all of them, then yes. Otherwise
> obviously no.
I dont' think ext4 has datachecksums yet? Let me rephrase that, I know 
there's a patch circulating I think but it wasn't recommended yet as it 
wasn't 'stable' yet? Anyway, I doubt my older ext4 disk has 
datachecksums yet. Metadata is pretty much default if i'm not mistaken 
:) So 0 errors from fsck, should mean all data is okay, right?
>
>> [ ... ] recommended to simply create a new array, with a new
>> FS on it, and copy all data over (Logically also with
>> /dev/md2, /dev/sda6 missing and later adding sdb6)?
> Given the number of people who ask here to recover the unique
> data they have on a RAID set, perhaps it is good to restate here
> that RAID does not mean "no longer need backups" :-).
It's not super crucial important data. That said, its never nice to 
loose data, right? :) Yes, always backup! :p

>
>>> [ ... ] I was wrong. I was so sure I made it o2, that I ruled
>>> out the possibility it being f2. [ ... ] Short story short,
>>> it turns out it was 128k chunks, Far2 offset. [ ... ]
> While you go the lengths of choosing particular layouts on
> specific filetrees, saving the output of '--scan' in
> 'mdadm.conf' seems strangely to have been a lower priority :-).
Oh I have mdadm.conf, but it doesn't list raid level, layout nor chunk 
sizes :( Only array name, meta-data and raid ID.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

