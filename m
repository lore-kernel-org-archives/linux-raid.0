From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Tue, 22 Dec 2015 10:48:38 -0600
Message-ID: <CAE9DZUQoNh2uU1h4okY0Fz5wzVv6-ZTnet9tS-dNQRHsLnPvNg@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<CAK2H+ed-3Z8SR20t8rpt3Fb48c3X2Jft=qZoiY9emC2nQww1xQ@mail.gmail.com>
	<CAE9DZUQHBycc5+Z2YrJtWZRYxOUMu3pgnaEQSrsyeCZEv8vndA@mail.gmail.com>
	<CAE9DZUT1v+CFZOs33CC+JrWcX_WHBu+WW78AynkWqJN+LLoqDA@mail.gmail.com>
	<CAK2H+ecMvDLdYLhMtMQbP7Ygw-VohG7LGZ2n7H+LAXQ1waJK3A@mail.gmail.com>
	<CAE9DZUSbt7Kfwd9S3K_SXY7fVRk-vq5RhrPzKs4XO8uhyfPh3Q@mail.gmail.com>
	<CAE9DZUQxT_5L0bW5m9SZ_d2GU6sZS8k0qD=g+o112qM4V=cJkw@mail.gmail.com>
	<22128.11867.847781.946791@quad.stoffel.home>
	<CAE9DZURepRB3k-pBnRg2Tx8GCzAr6zCzv+LJy4mK4CDdAkBYVQ@mail.gmail.com>
	<22128.35881.182823.556362@quad.stoffel.home>
	<CAE9DZUQNBPNXFs69JRU0Q82TQ4RjAgpsc7voMgEzuhSZhmDjig@mail.gmail.com>
	<CAE9DZUQqeCY__+8Fwg51PJc6zAk0J2Apm2TE3CRvxbFUf-xDKQ@mail.gmail.com>
	<CAK2H+eeD2k4yzuvL4uF_qKycp6A=XPe8pVF_J-7Agi8Ze89PPQ@mail.gmail.com>
	<5672BB7A.4050808@turmel.org>
	<CAE9DZUQj2TNX4Wpk5xbaCVzEgPq2D6Co7ZDNaAy-TOaB4hwZeA@mail.gmail.com>
	<567339F0.9000209@turmel.org>
	<CAE9DZUS+gmgTLr_4EUgLcPCPWknoqg640mCMZX46cxXeyT6RQA@mail.gmail.com>
	<CAE9DZUQoYtt3U5rGBAUtTuLS2N2uA80e=EcDD73fHq0qn6YH2w@mail.gmail.com>
	<CAFx4rwT8xgwZ0OWaLLsZvhMskiwmY54MzHgnnEPaswByeRrXxQ@mail.gmail.com>
	<CAFx4rwTUiMo=1+JXpY3P5BhZYSQC8MVYhTJfdJd7gL6r9WSAiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwTUiMo=1+JXpY3P5BhZYSQC8MVYhTJfdJd7gL6r9WSAiA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Dec 22, 2015 at 12:15 AM, Doug Dumitru <doug@easyco.com> wrote:
> My apologies for diving in so late.
>
> I routinely run 24 drive raid-5 sets with SSDs.  Chunk is set at 32K
> and the applications only writes "perfect" 736K "stripes".  The SSDs
> are Samsung 850 pros on dedicated LSI 3008 SAS ports and are at "new"
> preconditioning (ie, they are at full speed) or just over 500 MB/sec.
> CPU is a single E5-1650 v3.
>
> With stock RAID-5 code, I get about 1.8 GB/sec, q=4.
>
> Now this application is writing from kernel space
> (generic_make_request w/ q waiting for completion callback).  There
> are a lot of RMW operations happening here.  I think the raid-5
> background thread is waking up asynchronously when only a part of the
> write has been buffered into stripe cache pages.  The bio going into
> the raid layer is a single bio, so nothing is being carved up on the
> request end.  The raid-5 helper thread also saturates a cpu core
> (which is about as fast as you can get with an E5-1650).
>
> If I patch raid5.ko with special case code to avoid the stripe cache
> and just compute parity and go, the write throughput goes up above
> 11GB/sec.
>
> This is obviously an impossible IO pattern for most applications, but
> does confirm that the upper limit of (n-1)*bw is "possible", but not
> with the current stripe cache logic in the raid layer.
>
> Doug Dumitru
> WildFire Storage
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


> If I patch raid5.ko with special case code to avoid the stripe cache
> and just compute parity and go, the write throughput goes up above
> 11GB/sec.

Hi Doug.  This is really quite astounding and encouraging!  Would you
be willing to share your patch?  I am eager to give it a try for RAID
5 and 6.

> Now this application is writing from kernel space
> (generic_make_request w/ q waiting for completion callback).  There
> are a lot of RMW operations happening here.  I think the raid-5
> background thread is waking up asynchronously when only a part of the
> write has been buffered into stripe cache pages.

I am also anxious to hear from anyone who maintains the stripe cache
code.  I am seeing similar behavior when I monitor writes of perfectly
stripe-aligned blocks.  The # of RMWs are smallish and seem to vary,
but still I do not expect to see any of them!
