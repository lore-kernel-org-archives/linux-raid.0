From: "=?ISO-8859-1?Q?Thomas_Lang=E5s?=" <thomas.langaas@gmail.com>
Subject: Re: mdadm 2.6, linux 2.6.17, failed grow/reshape
Date: Tue, 20 Feb 2007 21:18:49 +0100
Message-ID: <6264d2ec0702201218g124c9e36kd79711afc5acc04d@mail.gmail.com>
References: <6264d2ec0702201047s7e732a2eq6b72f54af3f4ae4d@mail.gmail.com>
	 <17883.18091.699835.980907@notabene.brown>
	 <6264d2ec0702201122l2f718694k52ebbb1e9bd5717c@mail.gmail.com>
	 <6264d2ec0702201123l1b0ca58boe51fff8946c4ba0a@mail.gmail.com>
	 <17883.20708.151676.391623@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17883.20708.151676.391623@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/20/07, Neil Brown <neilb@suse.de> wrote:
> Is that all....
> Could it be that the kernel you are now using was not compiled with
>   CONFIG_MD_RAID5_RESHAPE=y
> that would explain an error with no message.  In fact it is the only
> thing that would explain the messages you got.  So please try with a
> kernel that has RAID5_RESHAPE enabled.

Which is correct, it seems, when looking at the config for the kernel:
# CONFIG_MD_RAID5_RESHAPE is not set

I need to figure out how to recompile a kernel and make my own bootcd
(the machine is in a state which only accepts boot cd now).

-- 
Thomas
