From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: RAID-10 keeps aborting
Date: Mon, 3 Jun 2013 10:22:12 -0700
Message-ID: <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com>
References: <51AC1440.7020505@zytor.com>
	<CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com>
	<51AC3283.4000403@zytor.com>
	<CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com>
	<51ACBAA0.40604@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51ACBAA0.40604@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jun 3, 2013 at 8:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/02/2013 11:14 PM, Dan Williams wrote:
>>
>> If I'm reading things correctly that may still result in failure since
>> md will still pass the REQ_WRITE_SAME bios down to the the devices and
>> will receive BLK_PREP_KILL for its trouble.  md only notices that
>> write same is disabled on underlying devices at assembly time.
>>
>
> I have to admit to not seeing where md (as opposed to dm) even looks for
> if the underlying devices have write same enabled.  It seems extremely
> likely that it is write same that is causing the headaches, though.
>

raid10 calls disk_stack_limits() after blk_queue_max_write_same_sectors().

...and here is where scsi considers failures as non-fatal in
sd_done().  I assume the REQ_QUIET is why there are no other kernel
messages.

        case ILLEGAL_REQUEST:
                if (sshdr.asc == 0x10)  /* DIX: Host detected corruption */
                        good_bytes = sd_completed_bytes(SCpnt);
                /* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
                if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
                        switch (op) {
                        case UNMAP:
                                sd_config_discard(sdkp, SD_LBP_DISABLE);
                                break;
                        case WRITE_SAME_16:
                        case WRITE_SAME:
                                if (unmap)
                                        sd_config_discard(sdkp, SD_LBP_DISABLE);
                                else {
                                        sdkp->device->no_write_same = 1;
                                        sd_config_write_same(sdkp);

                                        good_bytes = 0;
                                        req->__data_len = blk_rq_bytes(req);
                                        req->cmd_flags |= REQ_QUIET;
                                }
                        }
                }
                break;
