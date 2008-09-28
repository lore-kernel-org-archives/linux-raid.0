From: "Daniel Zetterman" <daniel.zetterman@gmail.com>
Subject: Re: Faster read performance DURING (?) resync on raid10
Date: Sun, 28 Sep 2008 13:06:09 +0200
Message-ID: <104f2a240809280406q22ab748s3dca796e70e63ec3@mail.gmail.com>
References: <19666016.post@talk.nabble.com>
	 <18652.25227.7530.435789@notabene.brown>
	 <104f2a240809261619m2512bddem11ea7960d86df2ff@mail.gmail.com>
	 <20080928022318.GA5634@rap.rap.dk>
	 <104f2a240809280345i74ddc8dej462a33383082dfe8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <104f2a240809280345i74ddc8dej462a33383082dfe8@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry guys, the offset is if course as stated near=3D2, far=3D1

Isn't near=3D2, far=3D2 better for raid10?



On Sun, Sep 28, 2008 at 12:45 PM, Daniel Zetterman
<daniel.zetterman@gmail.com> wrote:
> I'm using near=3D2, far=3D1, superblock version=3D00.90.03
>
> I'm not sure about offset, but its the default.
>
> I wan't to clearify one thing about the data, its not only a problem
> with encryption over raid, you get the same drop without encryption..=
=2E
> but you can remedy it by setting up the readahead, which gives no
> effect when using encryption.
>
>
> On Sun, Sep 28, 2008 at 4:23 AM, Keld J=F8rn Simonsen <keld@dkuug.dk>=
 wrote:
>> On Sat, Sep 27, 2008 at 01:19:50AM +0200, Daniel Zetterman wrote:
>>> I've done some more tests and here are the results:
>>>
>>> # bonnie++ during resync with readahead set to 512 (encrypted raid1=
0)
>>> kpax,4G,,,77308,21,34585,17,,,82073,33,384.8,1,,,,,,,,,,,,,
>>
>> It would be nice to know which layout (near,far,offset)
>> that you are using for the test. The expected results are quite
>> dependent on this.
>>
>> best regards
>> keld
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
