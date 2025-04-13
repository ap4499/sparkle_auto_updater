from typing import Any, Optional

import flet as ft
from flet.core.control import Control

class SparkleAutoUpdater(Control):
    """
    A Flet control to manage application updates using the auto_updater package.
    Requires a Sparkle feed URL. Typically added to `page.overlay.controls`.
    """

    def __init__(
        self,
        feed_url: Optional[str] = None,
        visible: Optional[bool] = None,
        data: Any = None,
    ):
        Control.__init__(
            self,
            visible=visible,
            data=data,
        )
        self.feed_url = feed_url

    def _get_control_name(self) -> str:
        return "sparkle_auto_updater" 

    def check_for_updates(self):
        self.invoke_method("check_for_updates")

    @property
    def feed_url(self) -> Optional[str]:
        return self._get_attr("feedUrl")

    @feed_url.setter
    def feed_url(self, value: Optional[str]):
        self._set_attr("feedUrl", value)