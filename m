From: David Brown <david.brown@hesbynett.no>
Subject: Re: "mdadm: Raid level 5 not permitted with --build" -- why is that?
Date: Mon, 25 Jun 2012 14:40:15 +0200
Message-ID: <4FE85C2F.5050007@hesbynett.no>
References: <CA+sTkh70JopNMbh0VQXDCq2MY+GHq0hQEPyKT1e9mRXxfk_2xw@mail.gmail.com> <20120625165242.117881e1@notabene.brown> <CA+sTkh7cYEmrujcRkvisFM1EksQBJ2kMKBfkd3RyDwr2-bvGpw@mail.gmail.com> <20120625175804.21b86b35@natsu> <CA+sTkh7Tv-F2fofWviF+X+Kp5-RLWmkTZveB6+jDHewLhhK50Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh7Tv-F2fofWviF+X+Kp5-RLWmkTZveB6+jDHewLhhK50Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: Roman Mamedov <rm@romanrm.ru>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/06/2012 14:12, Igor M Podlesny wrote:
> On 25 June 2012 19:58, Roman Mamedov <rm@romanrm.ru> wrote:
>> On Mon, 25 Jun 2012 19:33:23 +0800
>> Igor M Podlesny <for.poige+lsr@gmail.com> wrote:
>>
>>>> Feel free to send a patch.
>>>
>>>     =E2=80=94 "Feel free" to spend time digging into an area which =
isn't what
>>> you get paid for? At least what exactly should be patched this time=
,
>>> will you kindly tell us?
>>
>> Oh come on, that's just rude. I don't think Neil is paid by anyone t=
o answer
>> your questions here either.
>
>     Neither he was paid to add his "feel free", I guess, was he? Or w=
as
> that such an intricate payment?
>

Like many pieces of open source software, Linux md raid is written and=20
maintained by a mixture of volunteer work and corporate sponsorship.  I=
=20
have no idea how much Suse (or Novell) pay Neil for the work he does -=20
but he goes far beyond the call of duty in his support work on this=20
mailing list.  All he asks is that you ask your questions in a clear an=
d=20
polite way.  Putting the question in the subject but not in the body of=
=20
the email is not good enough - the post should have a good subject line=
=20
/and/ a good email body.  Why should Neil or anyone else take the time=20
to write a helpful reply to someone who cannot even be bothered to writ=
e=20
a good email?

Neil told you why md raid does not (currently) implement "--build" for=20
raid5.  And he suggested that if you want that behaviour to change, you=
=20
are always welcome to send a patch.  If you don't want to write an=20
implementation of the missing behaviour, that's fair enough too - very=20
few people respond to "feel free to send a patch" by actually sending a=
=20
patch.  But if you want to get annoyed and sarcastic, please keep your=20
comments to yourself.

mvh.,

David



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
