From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: RAID0 partition set to spare
Date: Sat, 31 Dec 2011 20:44:49 -0700
Message-ID: <CALFpzo6U60jccE5JuFwX0SFBsqcV3kTY1omhNm0cyKh7ZOUCvQ@mail.gmail.com>
References: <CA+q4O7N5D7c-dDYtW_BH3tUPK2NdAnq0agMAczTXQKji=QH3dw@mail.gmail.com>
	<4EFD9956.5050703@redhat.com>
	<CA+q4O7NS-2_1MxtXx5U4Qk66QHdXncUhm816utjuWVx8EJoGKQ@mail.gmail.com>
	<4EFEDF2A.5060408@redhat.com>
	<CA+q4O7NhcEhYLre45+u6V8nnmCg1EYi=3Lbn4_5AS6Ei5J1mTQ@mail.gmail.com>
	<CALFpzo6tUc1UrvJj9T1cWtgNyVjBHP89qnZPq8r_9Qz-m=eWog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALFpzo6tUc1UrvJj9T1cWtgNyVjBHP89qnZPq8r_9Qz-m=eWog@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Carlson <stevengcarlson@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

looks like adding a -f to your assemble command will clear the faulty
flag. I suppose I haven't looked hard enough. I'd still recommend
taking a dd of those partitions before playing too much (maybe pipe to
netcat to another machine if you don't have space locally), if you
care a lot about those photos. see "how to do everything with dd" :
http://www.linuxquestions.org/linux/answers/Applications_GUI_Multimedia=
/How_To_Do_Eveything_With_DD

On Sat, Dec 31, 2011 at 8:37 PM, Marcus Sorensen <shadowsor@gmail.com> =
wrote:
> Do you have spare drive space elsewhere or on another system where yo=
u can
> save an image these disk partitions? Then you can play and revert. I =
would
> be tempted to wipe the md superblocks and recreate the array with ide=
ntical
> properties. All of the data is intact unless there's a preexisting dr=
ive or
> corruption issue.
>
> In the past I have been doing failure testing with raid1s that I know=
 are
> clean, but one side shows as faulty spare because I temporarily yank =
a cord
> or something. I have not found a way other than recreating the array =
with
> assume-clean to clear the faulty flag without a full rebuild, but if =
there
> is a way then I suspect it would help you as well. As long as that sd=
b2 is
> marked faulty I don't think you can assemble as there's no place in r=
aid0 to
> recover from.
>
> On Dec 31, 2011 4:37 PM, "Steve Carlson" <stevengcarlson@gmail.com> w=
rote:
>>
>> > On Sat, Dec 31, 2011 at 4:08 AM, Jes Sorensen wrote:
>> > Hi Steve,
>> >
>> > What I meant here is that I would like to see the dmesg output at =
this
>> > point, to see if there were any read errors reported during the
>> > assembly.
>> >
>> >> I also ran extended self tests just to be thorough, and they both=
 came
>> >> back error free. =A0I'm unsure as to whether that puts them in th=
e clear
>> >> for bad sectors though.
>> >
>> > There were read errors in the dmesg output you posted earlier, whi=
ch is
>> > why I am wary of it.
>> >
>> > Cheers,
>> > Jes
>>
>> Jes,
>>
>> This is /var/log/messages from boot to stopping and reassembling md2=
=2E
>> I think this is what you wanted, I'm not sure what more I can give
>> you.
>>
>> http://dl.dropbox.com/u/2776371/raid/mdadm_stop_dmesg_c_mdadm_assemb=
le_var_log_message.txt
>>
>> -Steve
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
