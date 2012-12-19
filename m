From: Alex Pientka <alex.pientka@gmail.com>
Subject: Re: super slow reshape speed after power failure
Date: Wed, 19 Dec 2012 13:38:57 -0500
Message-ID: <CA+Z7oPgp_fu3sFzJefoTzvd-eQUCv7qqS38ZkHes3EqysuM8Ng@mail.gmail.com>
References: <CA+Z7oPhgrmC+nNxdRXjNPdOTSRbmy_aEYm=m_sO=7H6fBjh3yw@mail.gmail.com>
 <20690.985.485075.572934@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20690.985.485075.572934@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@raid2.to.sabi.co.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I tried values up to 32768, but no difference.
Alex


On Wed, Dec 19, 2012 at 1:13 PM, Peter Grandi <pg@raid2.to.sabi.co.uk> wrote:
>> [ ... ]  reshape was running it was running around 4mb/s,
>> which is slow to begin with. [ ... resync too ... ]
>
> A bigger value for 'md/stripe-cache' might help, alleviating
> some alignment issues, but usually it is not like 10 times
> better, but might be still worthwhile even if it will be still
> slow.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
