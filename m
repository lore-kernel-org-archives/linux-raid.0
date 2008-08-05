From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: [PATCH md] Speed up raid10 resync, especially for 'far' layout
Date: Tue, 5 Aug 2008 08:25:10 -0500
Message-ID: <cccedfc60808050625n7e8d3fd2t9d4548f3e64bacf7@mail.gmail.com>
References: <20080805101429.GA16040@rap.rap.dk>
	 <cccedfc60808050453g69074057y8d858fc7c4d6317b@mail.gmail.com>
	 <20080805132245.GA17635@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080805132245.GA17635@rap.rap.dk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 5, 2008 at 8:22 AM, Keld J=F8rn Simonsen <keld@dkuug.dk> wr=
ote:
> On Tue, Aug 05, 2008 at 06:53:12AM -0500, Jon Nelson wrote:
>> On Tue, Aug 5, 2008 at 5:14 AM, Keld J=F8rn Simonsen <keld@dkuug.dk>=
 wrote:
>> > Speed up raid10 resync, especially for 'far' layout
>> >
>> > This patch speeds up resync for raid10, especially for the 'far'
>> > layout, where reading is done in 32 MiB increments and the moving =
of
>> > heads is therefore much reduced compared to the previous 2 MiB siz=
e,
>> > nd the 'far' property of striping read can be employed.
>> >
>> > A speed up of more than 50 % has been reported.
>>
>> Actually, the time taken to 'check' the array was reduced by more th=
an 50%.
>
> Which corresponds to a speed up of more than 100 %.
>
> Did you  have any indications on whether there would still be room fo=
r
> improvements? What was the speed on the individual disks compared to
> their nominal speed?

Generally, very good. At or above the posted speed limit.



--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
