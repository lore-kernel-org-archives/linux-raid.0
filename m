From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Sun, 26 Jan 2014 20:34:11 -0700
Message-ID: <0EDC3349-197C-402E-8940-06AF44A164B6@colorremedies.com>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org> <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com> <52E2691E.4050701@turmel.org> <0466C42D-F51E-41D1-B220-F38EB43C1A38@colorremedies.com> <52E29CEF.7030408@turmel.org> <62EB0D79-9A50-4C50-ACBF-1C507D6F449B@colorremedies.com> <52E2AD10.5080208@turmel.org> <E222FBA0-8A1A-48EF-BEAA-BD059A8C1554@colorremedies.com> <52E2C5A3.1050803@turmel.org> <4ACB5D8F-CC0F-4CF2-96C7-03D05E40C89A@colorremedies.com> <52E3DCE4.4020909@turmel.org> <52E3F7FE.6000004@hardwarefreak.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E3F7FE.6000004@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 25, 2014, at 10:44 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
> Sector size has no bearing on hard read error probability.

http://www.seagate.com/tech-insights/advanced-format-4k-sector-hard-drives-master-ti/

See Figure 2: Media Defects and Areal Density. And also the paragraph under Figure 6.

They are making a claim that bigger sectors (assuming otherwise equal media density) translates into reduced potential for unrecoverable error.


>  The fact
> that a whole sector is failed on a single bit hard error is simply an
> artifact of one sector being the smallest request size possible from the
> host.

I accept that. But since there are two sector sizes, one URE does not represent the same amount of data loss.

> The probability is the same.  The only difference is how much you have
> to throw away.

Fine, but if you accept that the probability of URE is the same between conventional and AF disks, you accept that there are more bits being lost on AF disks than conventional disks. Yet the available data says the opposite is true.


Chris Murphy

