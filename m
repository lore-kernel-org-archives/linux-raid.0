From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID6 reshape, 2 disk failures
Date: Wed, 17 Oct 2012 13:35:59 -0600
Message-ID: <DBC580D6-7B49-411C-9224-2C9E73524F30@colorremedies.com>
References: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com> <C0A56E30-4D1A-44D3-8480-AC70706897B3@colorremedies.com> <CADNH=7GRyxe7c1NE-5WQUnkpmorchoYCWYtWgeabHkk4pzVMvg@mail.gmail.com> <235A81EB-2E6D-45AD-9175-29ABA1628632@colorremedies.com> <CADNH=7GaGCLdK2Rk_A6vPN+Th0z0QYT7mRV0KJH=CoAffuvb6w@mail.gmail.com> <D5D49452-3E33-4440-91A2-88F1F2E329D8@colorremedies.com> <CADNH=7G0d+7-Y5fwimV6U_u8ep1BAWzFP0jQJOm4RmAkk0urXQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7G0d+7-Y5fwimV6U_u8ep1BAWzFP0jQJOm4RmAkk0urXQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 17, 2012, at 1:03 PM, Mathias Bur=E9n wrote:
>=20
> Hm where do you get sda from? sda is the OS disk, an old SSD. (it
> currently holds the reshape backup file)

Oh. Misread. So it's sdh that's dead, and sde that's dying/pooping bad =
sector bullets.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
