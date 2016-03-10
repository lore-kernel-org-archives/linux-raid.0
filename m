From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] Fix regression during add devices
Date: Thu, 10 Mar 2016 12:59:28 +0800
Message-ID: <56E0FF30.1060807@suse.de>
References: <1457500818-1586-1-git-send-email-colyli@suse.de>
 <wrfjio0v4i7a.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjio0v4i7a.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Neil Brown <neilb@suse.com>
List-Id: linux-raid.ids

=D4=DA 16/3/10 =C9=CF=CE=E72:30, Jes Sorensen =D0=B4=B5=C0:
> Coly Li <colyli@suse.de> writes:
>> From: Hannes Reinecke <hare@suse.de>
>>
>> Commit d180d2aa2a17 ("Manage: fix test for 'is array failed'.")
>> introduced a regression which would not allow to re-add new
>> drivers to a failed array.
>>
>> The patch is written by Hannes Reinecke, Neil Brown points out
>> the buggy commit ID is d180d2aa2a17. Coly helps to submit the
>> patch to mdadm upstream.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> Cc: Coly Li <colyli@suse.de>
>> Cc: Neil Brown <neilb@suse.com>
>> ---
>>  Manage.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Coly,
>=20
> Thanks for the fix - please use "Fixes: " to indicate which patch
> introduced the bug, and the story of pushing the patch really belongs=
 in
> a comment below the --- line, so it doesn't go into git.
>=20
> I modified it to look like this - please let me know if you are OK wi=
th
> this.
>=20
> Thanks,
> Jes
>=20

Hi Jes,

It is OK to me, so I don't resend another fixed version.
Thanks for the fix up.

Coly
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
