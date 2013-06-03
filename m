From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-10 keeps aborting
Date: Mon, 03 Jun 2013 08:47:44 -0700
Message-ID: <51ACBAA0.40604@zytor.com>
References: <51AC1440.7020505@zytor.com> <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com> <51AC3283.4000403@zytor.com> <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/02/2013 11:14 PM, Dan Williams wrote:
> 
> If I'm reading things correctly that may still result in failure since
> md will still pass the REQ_WRITE_SAME bios down to the the devices and
> will receive BLK_PREP_KILL for its trouble.  md only notices that
> write same is disabled on underlying devices at assembly time.
> 

I have to admit to not seeing where md (as opposed to dm) even looks for
if the underlying devices have write same enabled.  It seems extremely
likely that it is write same that is causing the headaches, though.

	-hpa

