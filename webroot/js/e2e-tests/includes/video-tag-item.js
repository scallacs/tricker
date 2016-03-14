'use strict';

var Util = require('./util.js');

(function() {

    var util = new Util();

    function VideoTagItem(container) {
        expect(container.isPresent()).toBe(true);

        var self = this;
        self.container = container;

        self._dropdownOptions = new util.dropdown(self.container.element(by.css('.item-video-tag-options')));
        self._dropdownSharing = new util.dropdown(self.container.element(by.css('.item-video-tag-sharing')));
        self._title = self.container.element(by.css('.item-title'));
        expect(self._title.isPresent()).toBe(true);
        self._rider = self.container.element(by.css('.item-user-name'));
        
        
        self.openOptionLinkByState = function(state) {
            return self._dropdownOptions.open().then(function() {
                return self._dropdownOptions.menu().getLinkByState(state).click();
            });
        };
        self.openOptionLinkByCss = function(selector) {
            return self._dropdownOptions.open().then(function() {
                return self._dropdownOptions.menu().getLinkByCss(selector).click();
            });
        };
        
        self.openSharingLink = function(state) {
            return self._dropdownSharing.open().then(function() {
                return self._dropdownSharing.menu().getLinkByState(state).click();
            });
        };

        self.watch = function(){
            return self._title.click();
        };

        self.rider = function(){
            return self._rider.click();
        };

    };

    module.exports = VideoTagItem;
}());