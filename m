From: mark delfman <markdelfman@googlemail.com>
Subject: =?windows-1252?Q?Re=3A_MD_performance_options=3A_More_CPU=92s_or_more_Hz?=
	=?windows-1252?Q?=92s=3F?=
Date: Wed, 4 Nov 2009 12:19:00 +0000
Message-ID: <66781b10911040419t783f27d3x1ec3f79266a6d0f6@mail.gmail.com>
References: <66781b10911040149q165edf1s94a86f179f9af9fc@mail.gmail.com>
	 <921ca19c0911040408k6392b596t5f28cbf043e6d2c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <921ca19c0911040408k6392b596t5f28cbf043e6d2c0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sujit K M <sjt.kar@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

the performance is measured direct to the MD device and the drives are
connected direct via multi-channel SAS.  There is no intermediate
target layer (no fibre or iscsi etc).  When I mentioned iscsi is was
really talking about possible user configurations, sorry if this was
misleading

As we increase hardware performance the ratios of R0 and R6
performance stay much the same, so I was presuming that the drop in
performance is purely down to software overheads.  I am not saying it
is a bad drop, I am just wondering if we can reduce it by increasing
the software resources


On Wed, Nov 4, 2009 at 12:08 PM, Sujit K M <sjt.kar@gmail.com> wrote:
> I think this will be deeply involved to the RAID(Hardware) than the C=
PU/Cores.
>
> For example if you have an RAID0 at 1.5GBsec and an RAID6 At 700MBsec=
(as
> you have said) on Dual Core and Quad Core. I think There will be no p=
erformance
> gains with RAID0 or RAID6 on the software side. But if you use an RAI=
D of Higher
> Capacity it will be much more improved. I think it is very difficult
> to think in terms of
> RAID alone I think this is much more involved with Architectures like
> Fibre Channel,
> IP SAN etc.
>
> On Wed, Nov 4, 2009 at 3:19 PM, mark delfman <markdelfman@googlemail.=
com> wrote:
>> Hi... I am wondering if anyone can offer some advice on MD performan=
ce
>> related to CPU (speed and or cores). =A0The basic question (probably=
 too
>> basic) is =93for more MD performance are you better with more cpu=92=
s or a
>> faster single cpu=94. =A0(in an ideal world we would have lots of ve=
ry
>> fast CPUs, but given we never have enough money....).
>>
>> Is there any grounding to the following logic:
>>
>> Presuming that a RAID0 will deliver 1.5GBsec and a RAID6 circa
>> 700MBsec, I am guessing there are many complex reasons for the
>> difference, but one of the more obvious being the need for the CPU t=
o
>> perform all the necessary R6 overheads.
>>
>> If we look at a single RAID 6 configuration, then I am guessing if w=
e
>> increase the speed of the CPU from eg 2.0GHz to 2.8GHz (quad core
>> xeon) then the RAID6 calculations would be faster? =A0Would other
>> overheads also be faster and if so is there any know relationship
>> between CPU Hz and MD performance (maybe even rough rule of thumb eg
>> double cpu Hz and increase R6 performance by 20% etc)
>>
>> If however I start to think of multiple RAID6 configurations maybe v=
ia
>> iSCSI etc... then I wonder if MD would be better served with more CP=
Us
>> instead... for example 2 x Quad core 2.0GHz xeons instead of 1 x 2.8=
=2E
>> =A0This theory is dependent on linux / md effectively parallel
>> processing the overheads and I have no knowledge in this area... hen=
ce
>> the question.
>>
>> Any thoughts anyone?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> -- Sujit K M
>
> blog(http://kmsujit.blogspot.com/)
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
