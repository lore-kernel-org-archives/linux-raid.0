From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: --assume-clean on raid5/6
Date: Sat, 07 Aug 2010 14:28:55 +0200
Message-ID: <4C5D5187.7080109@stud.tu-ilmenau.de>
References: <D27CA15508148C428A25104ADEFAAC810661CD00@CORPUSMX50C.corp.emc.com>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D27CA15508148C428A25104ADEFAAC810661CD00@CORPUSMX50C.corp.emc.com>
Sender: linux-raid-owner@vger.kernel.org
To: brian.foster@emc.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Brian,

--assume-clean skips over the initial resync.  Which - if you will
create a filesystem after creating the array - is a time-saving idea.
But keep in mind: even if the disks are brand new and contain only
zeros, the parity would probably look not all zeros.  So reading from
such an array would be a bad idea.
But if the next thing you do is create LVM/filesystem etc., then all bit
read from the array will have been written to before (and by that are in
sync).

Stefan

Am 06.08.2010 03:19, schrieb brian.foster@emc.com:
> Hi all,
> 
> I've read in the list archives that use of --assume-clean on raid5
> (raid6?) is not safe assuming the member drives are not sync, but it's
> not clear to me as to why. I can see the content of an written raid5
> array change if I fail a drive out of the array (created w/
> --assume-clean), but data that I write prior to failing a drive remains
> intact. Perhaps I'm missing something. Could somebody elaborate on the
> danger/risk of using --assume-clean? Thanks in advance.
> 
> Brian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

