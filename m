From: Nix <nix@esperi.org.uk>
Subject: Re: Linux RAID version question
Date: Mon, 27 Nov 2006 20:39:11 +0000
Message-ID: <874pskwro0.fsf@hades.wkstn.nix>
References: <d33135570611231749p2d24eb51r7fc5a518afada0cd@mail.gmail.com>
	<981224FF5B88B349B7C1FED584D2620E07328A52@CORPUSMX50B.corp.emc.com>
	<d33135570611242354l74e383b7r37bdd8c81c001672@mail.gmail.com>
	<87vel1wyuf.fsf@hades.wkstn.nix>
	<d33135570611262245s148e6d6g2779acc858443eba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d33135570611262245s148e6d6g2779acc858443eba@mail.gmail.com> (Dragan Marinkovic's message of "27 Nov 2006 06:45:25 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: Dragan Marinkovic <marinkovic.dragan@gmail.com>
Cc: "Foster_Brian@emc.com" <Foster_Brian@emc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27 Nov 2006, Dragan Marinkovic stated:
> On 11/26/06, Nix <nix@esperi.org.uk> wrote:
>> Well, I assemble my arrays with the command
>>
>>     /sbin/mdadm --assemble --scan --auto=md
[...]
>> No metadata versions needed anywhere.
[...]
> But you do have to specify the version (other than 0.90) when you want
> to build the array for the first time, correct?

Unless you've specified it in mdadm.conf's CREATE stanza, sure.

-- 
`The main high-level difference between Emacs and (say) UNIX, Windows,
 or BeOS... is that Emacs boots quicker.' --- PdS
