From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: write-refresh md array (feature request)
Date: Tue, 10 Sep 2013 18:25:57 -0700
Message-ID: <CAA9_cmc+hJ9MrGyZDRXbUPNPcpgwm1RNvWQ4yX65zqKZy4puuQ@mail.gmail.com>
References: <20130910181905.GC21530@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130910181905.GC21530@khazad-dum.debian.net>
Sender: linux-raid-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Sep 10, 2013 at 11:19 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> (please CC me on replies).
>
> I've been in several situations where it would have been helpful to be able
> to refresh weak sectors by rewriting the whole md raid component device,
> without the need to increase array failure risk through a fail+remove+add
> cycle for the component device.
>
> How difficult would it be to implement a "refresh" as a Linux md driver
> sync_action, pigging back on "check" ?
>
> Are there any drawbacks to write-refreshing component devices?
>

Why is "check" insufficient?  If it trips over any bad sectors it will
re-write them.

--
Dan
