From: Steve Carlson <stevengcarlson@gmail.com>
Subject: Re: RAID0 partition set to spare
Date: Sat, 14 Jan 2012 15:42:58 -0600
Message-ID: <CA+q4O7NjK6Aj3Djs2g+qPu69=knOKvu9=wFy-YLdmw4Fi3k2Gw@mail.gmail.com>
References: <CA+q4O7N5D7c-dDYtW_BH3tUPK2NdAnq0agMAczTXQKji=QH3dw@mail.gmail.com>
	<4EFD9956.5050703@redhat.com>
	<CA+q4O7NS-2_1MxtXx5U4Qk66QHdXncUhm816utjuWVx8EJoGKQ@mail.gmail.com>
	<4EFEDF2A.5060408@redhat.com>
	<CA+q4O7NhcEhYLre45+u6V8nnmCg1EYi=3Lbn4_5AS6Ei5J1mTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+q4O7NhcEhYLre45+u6V8nnmCg1EYi=3Lbn4_5AS6Ei5J1mTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Dec 31, 2011 at 5:37 PM, Steve Carlson <stevengcarlson@gmail.co=
m> wrote:
>> On Sat, Dec 31, 2011 at 4:08 AM, Jes Sorensen wrote:
>> Hi Steve,
>>
>> What I meant here is that I would like to see the dmesg output at th=
is
>> point, to see if there were any read errors reported during the asse=
mbly.
>>
>>> I also ran extended self tests just to be thorough, and they both c=
ame
>>> back error free. =A0I'm unsure as to whether that puts them in the =
clear
>>> for bad sectors though.
>>
>> There were read errors in the dmesg output you posted earlier, which=
 is
>> why I am wary of it.
>>
>> Cheers,
>> Jes
>
> Jes,
>
> This is /var/log/messages from boot to stopping and reassembling md2.
> I think this is what you wanted, I'm not sure what more I can give
> you.
> http://dl.dropbox.com/u/2776371/raid/mdadm_stop_dmesg_c_mdadm_assembl=
e_var_log_message.txt
>
> -Steve



Hi all,

This is still unresolved.  What else could I try short of breaking and
rebuilding the array?

Thanks,
Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
